{ pkgs }:
with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "raccoon";
  version = "0.8.5";
  format = "wheel";
  src = fetchPypi {
    inherit version format;
    dist = "py3";
    python = "py3";
    pname = "raccoon_scanner";
    sha256 = "sha256-hUiSxC+y5hszqHAM7oKXIE9/k1dh49csQk1CUiO+Ri8=";
  };
  doCheck = false;
  propagatedBuildInputs = [
    xmltodict
    dnspython
    requests
    lxml
    beautifulsoup4
    click
    fake-useragent
    pysocks
  ];
}
