#!/usr/bin/env python
from setuptools import setup, find_packages
from os import path

here = path.abspath(path.dirname(__file__))

setup(
    name='brody_lab_pipeline',
    version='0.0.0',
    description='DataJoint pipeline for Carlos Bordy Lab',
    author='Vathes',
    author_email='support@vathes.com',
    packages=find_packages(exclude=[]),
    install_requires=['datajoint>=0.13', 'dash', 'dash-bootstrap-components', 'python-dotenv'],
)
