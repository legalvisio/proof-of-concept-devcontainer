#!/bin/bash

pwd
sleep 30
psql postgresql://postgres:postgres@database:5432/postgres < fixtures/structure.sql
psql postgresql://postgres:postgres@database:5432/postgres < fixtures/demo-data.sql