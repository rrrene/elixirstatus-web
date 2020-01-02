alias ElixirStatus.User
alias ElixirStatus.Repo

all = [
  %User{
    full_name: "René Föhring",
    user_name: "rrrene",
    email: "rrrene@example.com",
    provider: "github"
  },
  %User{
    full_name: "",
    user_name: "rizafahmi",
    email: "rizafahmi@example.com",
    provider: "github"
  },
  %User{
    full_name: "",
    user_name: "joekain",
    email: "joekain@example.com",
    provider: "github"
  },
  %User{
    full_name: "",
    user_name: "michalmuskala",
    email: "michalmuskala@example.com",
    provider: "github"
  },
  %User{
    full_name: "Hans",
    user_name: "Hanspagh",
    email: "Hanspagh@example.com",
    provider: "github"
  },
  %User{
    full_name: "",
    user_name: "h4cc",
    email: "h4cc@example.com",
    provider: "github"
  },
  %User{
    full_name: "",
    user_name: "philnash",
    email: "philnash@example.com",
    provider: "github"
  },
  %User{
    full_name: "",
    user_name: "nithinbekal",
    email: "nithinbekal@example.com",
    provider: "github"
  },
  %User{
    full_name: "",
    user_name: "your-name-here",
    email: "your-name-here@example.com",
    provider: "github"
  }
]
Enum.each(all, &Repo.insert!(&1))
