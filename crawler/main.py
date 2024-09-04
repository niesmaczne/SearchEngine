import os

import feedparser # type: ignore
import psycopg2  # Required by SQLAlchemy - create_engine
import yaml
from bs4 import BeautifulSoup
from feedparser.util import FeedParserDict # type: ignore
from sqlalchemy import TIMESTAMP, Column, Integer, String, create_engine, func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import declarative_base, sessionmaker

# Read the RSSFeed connection string from environment variable
RSSFeed_connection_string = os.getenv("DATABASE_URL")
if not RSSFeed_connection_string:
    raise ValueError(
        "No database connection string found in the environment variable DATABASE_URL"
    )

# Create SQLAlchemy engine
engine = create_engine(RSSFeed_connection_string)

# Create a configured "Session" class
Session = sessionmaker(bind=engine)

# Create a base class for models
Base = declarative_base()


def read_creators() -> list:
    with open("config.yaml", "r") as file:
        creators = yaml.safe_load(file)["rssFeeds"]
    return creators


def get_info(https: str) -> list:
    response = feedparser.parse(https)
    print(len(response.entries), "entries")
    entries: list[RSSFeed] = []

    for i in response.entries:
        entry = to_rss_feed(i)
        entries.append(entry)
    return entries


def to_rss_feed(obj: FeedParserDict) -> "RSSFeed":
    title = obj.title
    summary = BeautifulSoup(obj.summary).get_text()
    try:
        author = obj.author
    except:
        author = None
    try:
        creation_time = obj.published
    except:
        creation_time = None
    url = obj.link

    return RSSFeed(
        title=title,
        summary=summary,
        author=author,
        creation_time=creation_time,
        url=url,
    )


class RSSFeed(Base): # type: ignore
    __tablename__ = "rss_feed"

    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(255), nullable=False)
    summary = Column(String(32000))
    author = Column(String(255))
    creation_time = Column(TIMESTAMP, server_default=func.now())
    url = Column(String(2083))

    def __repr__(self) -> str:
        return f"id={self.id!r}, title={self.title!r}, summary={self.summary!r}, author={self.author!r}, creation_time={self.creation_time!r}, url={self.url!r}"


def update_RSSFeed(list) -> None:
    session = Session()
    for i in list:
        try:
            # Check if the feed with the same URL already exists
            existing_feed = session.execute(
                select(RSSFeed).filter_by(url=i.url)
            ).scalar_one_or_none()

            if existing_feed is None:
                # Create a new feed entry
                new_feed = RSSFeed(
                    title=i.title, summary=i.summary, author=i.author, url=i.url
                )
                session.add(new_feed)
                session.commit()
                print("New feed inserted successfully.")
            else:
                print("Feed already exists, no insertion performed.")
        except IntegrityError as e:
            print(f"Error occurred: {e}")
            session.rollback()
        finally:
            session.close()


if __name__ == "__main__":
    creators = read_creators()
    for i in creators:
        data = get_info(i)
        update_RSSFeed(data)
