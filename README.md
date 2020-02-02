# ElixirStatus [![Inline docs](http://inch-ci.org/github/rrrene/elixirstatus-web.svg?branch=master)](http://inch-ci.org/github/rrrene/elixirstatus-web) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/rrrene/elixirstatus-web.svg)](https://beta.hexfaktor.org/github/rrrene/elixirstatus-web) [![ElixirWeekly](https://img.shields.io/badge/featured-ElixirWeekly-a054ff.svg)](https://elixirweekly.net)

I already integrated Phoenix in my project [Inch CI](https://inch-ci.org/), but have not yet build a frontend site with it. I want to do this here.

This will become http://elixirstatus.com, my first *complete* Phoenix project.

## What will this be?

It will be a small site for developers to post their creations: new projects, blog posts and version updates.

No link-sharing in a wider sense, just posting your own stuff.

![Screenshot](http://trivelop.de/public/images/2015-07-05/elixirstatus2.png)

So it won't be a large site, but it will make up for it by being well-integrated into existing services and trends, like GitHub, Twitter, and RSS.

It will make it easy to follow new projects and blogs in the Elixir community.

## Don't we have this already?

Yes and no. I always have the feeling my project and update announcements get drowned by so much else that is out there (be it on the mailing list or on #myelixirstatus). And you can't get mentioned in Elixir Radar *every* week :grin:

The important thing here is this is inspired by the original RubyFlow. Giving developers a venue where they can be heard whether they are a Phoenix contributor or an unknown coder who wrote his first blog post about recursion. Equal voice for everyone.

## Open Roadmap #21

- [x] Build and launch [landing page](http://elixirstatus.com/)
- [x] Add postings
- [x] GitHub integration
- [x] Twitter setup
- [ ] Design functional UI
- [ ] Beta phase ([described here](https://github.com/rrrene/elixirstatus-web/issues/21))
- [ ] Fun!



## Usage

Create the `secret` file for target environment:

    ```bash
    $ cp config/dev.secret.example.exs config/dev.secret.ex
    ```

_If you are in `prod` environment you to copy the `prod.secret.example.exs` instead_

To start the ElixirStatus application:

1. Install mix dependencies with:
    ```bash
    $ mix deps.get
    ```

2. Install Node.js dependencies, for the asset pipeline, with:
    ```bash
    $ npm install
    ```

3. Make sure you have PostgreSQL installed and then configure the database accordingly in `config/dev.exs` and `config/test.exs`.

4. Create and migrate the database with:
    ```bash
    $ mix ecto.create
    $ mix ecto.migrate
    ```
5. Seed database with:

    ```bash
    $ mix run priv/repo/seeds/seed.exs
    ```
6. [Register a GitHub application](https://github.com/settings/applications/new) to enable user authentication with GitHub:

    Application name: `<your choice>`

    Homepage-URL: `http://localhost:4000`

    Application description: `<your choice>`

    Authorization callback URL: `http://localhost:4000/auth/callback`

7. Start Phoenix endpoint with
    ```bash
    CLIENT_ID=<your_github_app_client_id> CLIENT_SECRET=<your_github_app_client_secret> mix phoenix.server
    ```

Now you can visit `localhost:4000` from your browser.



## Contribution

I am no designer (as [Inch CI](https://inch-ci.org/) probably shows) *and* still relatively new to Elixir myself. So if you want to be part if this little exercise and help out, just ping me [on Twitter](https://twitter.com/rrrene) or [send me an email](https://github.com/rrrene).




## Author

René Föhring (@rrrene)

But ElixirStatus is a community project and received fantastic contributions from these community members:

- Hans Pagh (@Hanspagh)
- Phil Nash (@philnash)
- Riza Fahmi (@rizafahmi)
- Peter Suschlik (@splattael)



## Credits

ElixirStatus takes inspiration from RubyFlow, which helped me a lot to get my Ruby projects noticed.

People posting a wild mix of interesting stuff, discoveries and banter under the hashtag #myelixirstatus on Twitter inspired the name.



## License

ElixirStatus is released under the MIT License. See the LICENSE file for further
details.
