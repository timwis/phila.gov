[![Tested on BrowserStack](https://img.shields.io/badge/browserstack-tested-brightgreen.svg)](https://www.browserstack.com/)


# phila.gov

The phila.gov site is WordPress running behind Nginx on an AWS instance. The entire machine setup is kept in this repo. 

## Local development

1. [Install docker](https://www.docker.com/community-edition)
2. Clone this repository
3. Download a recent `.sql` file database dump into the `db-data` directory
4. Run `docker-compose up` and browse to `https://localhost:8080`

If you'd like to have private plugins installed, set the environment variables
`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` before you run `up`. One way
to do that is to copy `.env.sample` to `.env` and fill them in there.
