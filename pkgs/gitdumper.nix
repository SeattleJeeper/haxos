{ python3Packages
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "gitdumper";
  version = "1.0.6";
  pyproject = true;
  src = fetchPypi {
    inherit version;
    pname = "git-dumper";
    sha256 = "sha256-Dsj1ec6p0nFaGT3abf+mOrJgnH0gci1OQE2Roi5PfJQ=";
  };
  doCheck = false;
  nativeBuildInputs = with python3Packages; [
    setuptools
  ];
  propagatedBuildInputs = with python3Packages; [
    pysocks
    requests
    beautifulsoup4
    dulwich
  ];
}

