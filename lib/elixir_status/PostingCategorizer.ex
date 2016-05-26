defmodule ElixirStatus.PostingCategorizer do
  alias ElixirStatus.Posting

  @categorizers [
      __MODULE__.IsProjectUpdate,
      __MODULE__.IsBlogPost
    ]


  def run(hash) do
    Enum.map(@categorizers, fn module -> {module.type, module.run(hash)} end)
  end

  defmodule IsProjectUpdate do
    @link_to_github ~r/https\:\/\/github.com\/[^\/]+\/[^\/]+/
    @link_to_github_release ~r/https\:\/\/github.com\/[^\/]+\/[^\/]+\/releases\/tag\/.+/
    @link_to_package ~r/https\:\/\/rubygems.org\/gems\/[^\/]+/
    @version_number ~r/[v\s]\d*\.\d*\.\d*/
    @release_mentioned ~r/\Wreleased?(\W|\E)/i
    @features_or_improvements_mentioned ~r/\W(improved?|improvements?|featured?|features)(\W|\E)/i

    @title_regex [
      {:version_number, @version_number, 0.4},
      {:release_mentioned, @release_mentioned, 0.1},
    ]
    @text_regex [
      {:version_number, @version_number, 0.1},
      {:link_to_github, @link_to_github, 0.1},
      {:link_to_github_release, @link_to_github_release, 0.4},
      {:link_to_package, @link_to_package, 0.4},
      {:release_mentioned, @release_mentioned, 0.1},
      {:features_or_improvements_mentioned, @features_or_improvements_mentioned, 0.1},
    ]


    def type, do: :project_update

    def run(%Posting{title: title, text: text}) do
      {t_sum, t_roles} = increment_if_matching(@title_regex, title)
      {b_sum, b_roles} = increment_if_matching(@text_regex, text)
      {t_sum + b_sum, t_roles ++ b_roles}
    end

    def increment_if_matching(list, string \\ "", sum \\ 0, roles \\ [])

    def increment_if_matching([{role, regex, val} | tail], string, sum, roles) do
      if String.match?(string, regex) do
        increment_if_matching(tail, string, sum + val, roles ++ [role])
      else
        increment_if_matching(tail, string, sum, roles)
      end
    end

    def increment_if_matching([], string, sum, roles), do: {sum, roles}
  end

  defmodule IsBlogPost do
    @title_regex [
    ]
    @text_regex [
      {:typical_subdomain_or_dir, ~r/\/(blog|posts?|articles?)(\.|\/)+/, 0.1},
      {:year_month_day_slug,      ~r/\/\d{4}\/\d{2}\/\d{2}\/\D+/, 0.1},
      {:year_month_slug,          ~r/\/\d{4}\/\d{2}\/\D+/, 0.1},
    ]

    def type, do: :blog_post

    import ElixirStatus.PostingCategorizer.IsProjectUpdate

    def run(%Posting{title: title, text: text}) do
      {t_sum, t_roles} = increment_if_matching(@title_regex, title)
      {b_sum, b_roles} = increment_if_matching(@text_regex, text)
      {t_sum + b_sum, t_roles ++ b_roles}
    end
  end
end
