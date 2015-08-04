exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        'js/app.js': /^web\/static\/(js\/app|vendor)/,
        'js/admin.js': /^web\/static\/(js\/admin|vendor)/
      },
      order: {
        before: [
          'web/static/vendor/jquery-1.11.3.min.js'
        ]
      }
    },
    stylesheets: {
      joinTo: {
        'css/app.css': /^(web\/static\/css\/app)/,
        'css/admin.css': /^(web\/static\/css\/admin)/
      },
      order: {
        before: [
          'web/static/css/app/layout.scss',
          'web/static/css/app/typo.scss'
        ]
      }
    },
    templates: {
      joinTo: 'js/app.js',
      order: {
        before: [
          'web/static/vendor/jquery-1.11.3.min.js'
        ]
      }
    }
  },

  // Phoenix paths configuration
  paths: {
    // Which directories to watch
    watched: ["web/static", "test/static"],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/^(web\/static\/vendor)/]
    }
  }
};
