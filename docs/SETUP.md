1. Clone repository

1. Restore `.env`

    ```
    $ cp .env.example .env
    ``` 

1. Connect with ComicVine API

    1. Get API key from https://comicvine.gamespot.com/api/
    2. Save API key as `COMIC_VINE_API` in `.env`

1. Connect with Grand Comics Database data

    1. Setup mysql database
    1. Download mysql dump from https://www.comics.org/download/
    1. Restore dump
        ```
        $ mysql -u username -p database_name < file.sql
        ```
    1. Fill `GCD_DATABASE` with url:
        ```
        mysql2://[username]:[password]@[host]:[port]/[database_name]
        ```

1. Connect with Marvel API

    1. Get public key and private key from https://developer.marvel.com/account
    1. Save public key and private key as `MARVEL_PUBLIC_KEY` and `MARVEL_PRIVATE_KEY` 

1. Connect with ComicBookDB

    1. Deploy ComicBookDB wrapper to US zone server
    1. Set `CBDB_HOST`, `CBDB_BASIC_USER`, `CBDB_BASIC_PASSWORD` in `.env`

1. Run API
    ```
    $ bundle exec rackup
    $ bundle exec shotgun config.ru # with hot reload
    ```
