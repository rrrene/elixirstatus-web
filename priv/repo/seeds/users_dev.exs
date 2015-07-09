alias ElixirStatus.User
alias ElixirStatus.Repo

all = [
  %User{
    id: 1,
    full_name: "René Föhring",
    user_name: "rrrene",
    email: "rrrene@example.com",
    provider: "github"
  },
  %User{
    id: 2,
    full_name: "",
    user_name: "rizafahmi",
    email: "rizafahmi@example.com",
    provider: "github"
  },
  %User{
    id: 3,
    full_name: "",
    user_name: "joekain",
    email: "joekain@example.com",
    provider: "github"
  },
  %User{
    id: 4,
    full_name: "",
    user_name: "michalmuskala",
    email: "michalmuskala@example.com",
    provider: "github"
  },
  %User{
    id: 5,
    full_name: "Hans",
    user_name: "Hanspagh",
    email: "Hanspagh@example.com",
    provider: "github"
  },
  %User{
    id: 6,
    full_name: "",
    user_name: "h4cc",
    email: "h4cc@example.com",
    provider: "github"
  },
  %User{
    id: 7,
    full_name: "",
    user_name: "philnash",
    email: "philnash@example.com",
    provider: "github"
  },
  %User{
    id: 8,
    full_name: "",
    user_name: "nithinbekal",
    email: "nithinbekal@example.com",
    provider: "github"
  },
  %User{
    id: 100,
    full_name: "",
    user_name: "your-name-here",
    email: "your-name-here@example.com",
    provider: "github"
  }
]
Enum.each(all, &Repo.insert!(&1))
