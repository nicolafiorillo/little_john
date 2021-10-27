# LittleJohn

## Usage

Build and run with the following commands.

### Build

`docker build -t little_john .`

### Run server

`docker run -e PORT=8080 -p 8080:8080 -t little_john`

## Remove built docker image

`docker rmi little_john`

---

## Connect to server

Copy and paste user token in `curl` command.\
Available users (with tokens) are printed in server console log when server is started.\
E.g.:
```Bash
Listening to 127.0.0.1:8080
Registered users (token): ["YWRjMGEwY2UtNTkzMC00Y2E1LTg3NTgtMTA0ZjJjMzJhODhmOmFkYzBhMGNlLTU5MzAtNGNhNS04NzU4LTEwNGYyYzMyYTg4Zg==", "MTcxZDgyYzEtYzcwMS00ZmZjLWJmMjYtMzk5YjE5YTE5YzdlOjE3MWQ4MmMxLWM3MDEtNGZmYy1iZjI2LTM5OWIxOWExOWM3ZQ==", "ZjZlMjY2MzItOWQ1Ni00MzhjLWE0YWEtYjQ0ZTAyZGY2NTU3OmY2ZTI2NjMyLTlkNTYtNDM4Yy1hNGFhLWI0NGUwMmRmNjU1Nw==", "OTI4YTFhY2QtODBjMi00MWE1LTlmOWUtOGEzZWM5OWFlZjYxOjkyOGExYWNkLTgwYzItNDFhNS05ZjllLThhM2VjOTlhZWY2MQ==", "OWRmYmQ1OTctYTI1YS00YTlmLWIzMTMtYWJhNjczZTJmMTFiOjlkZmJkNTk3LWEyNWEtNGE5Zi1iMzEzLWFiYTY3M2UyZjExYg=="]
```

### Get user's portfolio

`curl -X GET http://localhost:8080/tickers -H "Authorization: Basic {token}"`

### Get ticker history

`curl -X GET http://localhost:8080/tickers/AAPL/history -H "Authorization: Basic {token}}"`




