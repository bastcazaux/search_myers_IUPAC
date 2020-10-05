from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("search_myers_IUPAC.pyx")
)
