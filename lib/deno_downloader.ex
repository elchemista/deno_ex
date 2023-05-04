defmodule DenoEx.DenoDownloader do
  @moduledoc """
  This module is responsible for fetching the deno executable from GitHub.
  """

  use OctoFetch,
    latest_version: "1.33.1",
    github_repo: "denoland/deno",
    download_versions: %{
      "1.33.1" => [
        {:darwin, :arm64, "e4a531d061fa8151070a6323e35a23620d6889297b810b6424a5125842ecbb47"}
      ]
    }

  @impl true
  def download_name(_version, :darwin, :arm64), do: "deno-aarch64-apple-darwin.zip"
  def download_name(_version, :darwin, arch), do: "deno-#{arch}-apple-darwin.zip"
  def download_name(_version, :linux, arch), do: "deno-#{arch}-unknown-linux-gnu.zip"

  @doc """
  This function downloads the deno executable and also sets the permissions of the
  executable.
  """
  @spec install(install_path :: String.t(), permissions :: integer()) :: {:ok, path :: String.t()}
  def install(install_path, permissions)
      when is_binary(install_path) and is_integer(permissions) do
    with :ok <- File.mkdir_p(install_path),
         {:ok, [path], []} <-
           DenoEx.DenoDownloader.download(install_path) do
      File.chmod(path, permissions)
      {:ok, path}
    end
  end
end
