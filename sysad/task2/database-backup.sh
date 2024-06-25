pg_dump -Fc -h postgres -U postgres -d records -f records.dump
#to restore database use pg_records -h postgres -U postgres -d records records.dump