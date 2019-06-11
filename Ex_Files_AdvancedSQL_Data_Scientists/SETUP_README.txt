How to setup up a postgres database:

1-> login with super user "postgres" using psql
2-> create a user with query "CREATE USER "test" WITH PASSWORD 'test'
3-> alter user permisson "ALTER USER test WITH superuser createdb"
4-> "DROP ROLE test"
5-> CREATE DATABASE test_db

Note:
SQLTOOL extension on vs code we can connet to databases.