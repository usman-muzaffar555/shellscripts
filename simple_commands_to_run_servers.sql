cd /usr/edb/as10/bin/
./pg_ctl -D /var/lib/edb/as10/data/ -o "-p 5444" start

cd ../../as11/bin/
./pg_ctl -D /var/lib/edb/as11/data/ -o "-p 5445" start

cd ../../as12/bin/
./pg_ctl -D /var/lib/edb/as12/data/ -o "-p 5446" start

cd ../../as13/bin/
./pg_ctl -D /var/lib/edb/as13/data/ -o "-p 5447" start

cd ../../as14/bin/
./pg_ctl -D /var/lib/edb/as14/data/ -o "-p 5448" start

cd ../../as15/bin/
./pg_ctl -D /var/lib/edb/as15/data/ -o "-p 5449" start