Propel issue 

When working with a legacy database that has field like the following

```mysql
  `field_name` decimal(11,0) DEFAULT NULL
```

propel generates a wrong schema.xml ommitting the scale of the field

This can be reproduced using `make test` where a second migration will be created
because the schema does not match with the generated migration.

If you run into trouble on OSX

`Unable to open PDO connection [wrapped: SQLSTATE[HY000] [2002] No such file or directory]`
On Terminal, execute these commands

```bash
sudo mkdir /var/mysql/
sudo ln -s /private/tmp/mysql.sock /var/mysql/mysql.sock
```


I think the schema should look like the `expected_schema.xml` to see the differences run `make migrations && diff generated-reversed-database/schema.xml expected_schema.xml`
