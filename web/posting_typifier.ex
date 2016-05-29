defmodule ElixirStatus.PostingTypifier do
  alias ElixirStatus.Posting

  @categorizers [
      __MODULE__.IsProjectUpdate,
      __MODULE__.IsBlogPost
    ]

  def run(posting) do
    all =
      @categorizers
      |> Enum.map(&(&1.run(posting)))
      |> Enum.sort
      |> Enum.reverse

    sum_all =
      Enum.reduce(all, 0, fn({points, _type, _}, acc) -> points + acc end)

    %{
      "all" => all,
      "choice" => choose(all, sum_all)
    }
  end

  defp choose(_, 0), do: nil
  defp choose([], _sum_all) do
    nil
  end
  defp choose([{sum_all, type, _}|tail], sum_all) do
    type
  end
  defp choose([{points, type, _}|tail], sum_all) when points > 0.5 do
    type
  end
  defp choose([{points, type, _}|tail], sum_all) do
    choose(tail, sum_all)
  end


  defmodule IsProjectUpdate do
    @link_to_github ~r/https\:\/\/github.com\/[^\/]+\/[^\/]+/
    @link_to_github_release ~r/https\:\/\/github.com\/[^\/]+\/[^\/]+\/releases\/tag\/.+/
    @link_to_package ~r/https\:\/\/rubygems.org\/gems\/[^\/]+/
    @version_number ~r/[v\s]\d*\.\d*\.\d*/
    @release_mentioned ~r/\Wreleased?(\W|\E)/i
    @features_or_improvements_mentioned ~r/\W(improved?|improvements?|featured?|features)(\W|\E)/i

    @title_regex [
      {:version_number, 0.4, @version_number},
      {:release_mentioned, 0.1, @release_mentioned},
    ]
    @text_regex [
      {:version_number, 0.1, @version_number},
      {:link_to_github, 0.1, @link_to_github},
      {:link_to_github_release, 0.4, @link_to_github_release},
      {:link_to_package, 0.4, @link_to_package},
      {:release_mentioned, 0.1, @release_mentioned},
      {:features_or_improvements_mentioned, 0.1, @features_or_improvements_mentioned},
    ]

    def run(%Posting{title: title, text: text}) do
      {t_sum, t_roles} = increment_if_matching(@title_regex, title)
      {b_sum, b_roles} = increment_if_matching(@text_regex, text)
      {t_sum + b_sum, :project_update, t_roles ++ b_roles}
    end

    def increment_if_matching(list, string \\ "", sum \\ 0, roles \\ [])

    def increment_if_matching([{role, val, regex} | tail], string, sum, roles) do
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
      {:typical_title_elements, 0.1, ~r{^(why|how)}i},
    ]
    @text_regex [
      {:typical_domain, 0.3, ~r{https://medium.com/(p/|\@)}},
      {:typical_subdomain_or_dir, 0.2, ~r/\/(blog|posts?|articles?)(\.|\/)+/},
      {:year_month_day_slug, 0.2, ~r/\/\d{4}\/\d{2}\/\d{2}\/\D+/},
      {:year_month_slug, 0.2, ~r/\/\d{4}\/\d{2}\/\D+/},
      {:blog_post_mentioned, 0.1, ~r/blog[\s-]post/},
    ]

    import ElixirStatus.PostingTypifier.IsProjectUpdate

    def run(%Posting{title: title, text: text}) do
      {t_sum, t_roles} = increment_if_matching(@title_regex, title)
      {b_sum, b_roles} = increment_if_matching(@text_regex, text)
      {t_sum + b_sum, :blog_post, t_roles ++ b_roles}
    end
  end
end
