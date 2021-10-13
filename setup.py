#!/usr/bin/env python
from setuptools import setup, find_packages
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'requirements.txt')) as f:
    requirements = f.read().splitlines()

setup(
    name='brody_lab_pipeline',
    version='0.0.0',
    description='DataJoint pipeline for Carlos Brody Lab',
    author='DataJoint',
    author_email='support@datajoint.com',
    packages=find_packages(exclude=[]),
    install_requires=requirements,
)
