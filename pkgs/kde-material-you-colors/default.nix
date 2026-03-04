{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dbus-python,
  numpy,
  pillow,
  materialyoucolor,
  magic,
}:

buildPythonPackage rec {
  pname = "kde-material-you-colors";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "kde-material-you-colors";
    tag = "v${version}";
    hash = "sha256-qiaFHu4eyX73cAbMdoP46SiiFjNWx2vXWVzEbCsTNBI=";
  };

  build-system = [ setuptools ];
  dependencies = [
    dbus-python
    numpy
    pillow
    materialyoucolor
    magic
  ];

  pythonImportsCheck = [ "kde_material_you_colors" ];

  doCheck = false; # no unittests, and would require KDE desktop environment

  meta = {
    homepage = "https://store.kde.org/p/2136963";
    description = "Automatic color scheme generator from your wallpaper for KDE Plasma powered by Material You";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "kde-material-you-colors";
  };
}
