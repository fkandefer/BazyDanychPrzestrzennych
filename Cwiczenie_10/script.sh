#!/bin/bash

# Skrypt: Automatyzacja przetwarzania danych klientów
# Autor: Filip Kandefer
# Data: 19.01.2025

# Parametry
NUMERINDEKSU="418289"
TIMESTAMP=$(date +%m%d%Y)
URL_FILE="https://home.agh.edu.pl/~wsarlej/Customers_Nov2024.zip"
URL_OLD_FILE="https://home.agh.edu.pl/~wsarlej/Customers_old.csv"
OLD_FILE="Customers_old.csv"
DB_HOST="localhost"
DB_USER="postgres"
DB_NAME="cw_10"
EMAIL_RECIPIENT="filip.kandefer03@gmail.com"
LOG_FILE="PROCESSED/script_log_${TIMESTAMP}.log"
PROCESSED_DIR="PROCESSED"

# Tworzenie folderu na przetworzone pliki
mkdir -p $PROCESSED_DIR

# Funkcja logowania
log() {
  echo "$(date +%Y%m%d%H%M%S) - $1" | tee -a $LOG_FILE
}

# Obsługa błędów
handle_error() {
  log "ERROR: $1"
  exit 1
}

# Sprawdzenie dostępności narzędzi
command -v wget >/dev/null 2>&1 || handle_error "wget is not installed"
command -v unzip >/dev/null 2>&1 || handle_error "unzip is not installed"
command -v zip >/dev/null 2>&1 || handle_error "zip is not installed"
command -v mailx >/dev/null 2>&1 || handle_error "mailx is not installed"

# Tworzenie rozszerzenia PostGIS
log "Ensuring PostGIS extension is installed..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS postgis;" || handle_error "Failed to create PostGIS extension"

# Pobieranie plików
log "Downloading file..."
wget -q $URL_FILE -O Customers_Nov2024.zip || handle_error "Failed to download Customers_Nov2024.zip"
wget -q $URL_OLD_FILE -O $OLD_FILE || handle_error "Failed to download $OLD_FILE"

# Rozpakowanie pliku ZIP
log "Unzipping file..."
unzip -o Customers_Nov2024.zip -d . || handle_error "Failed to unzip Customers_Nov2024.zip"

# Walidacja i deduplikacja danych
log "Validating and cleaning file..."
awk -F, '
BEGIN {valid_count = 0; invalid_count = 0}
NR == 1 {header = $0; n = split($0, columns); print header > "Customers_Nov2024.valid"}
NR > 1 {
  if ($3 ~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ && NF == n) {
    if (!seen[$0]++) {
      print $0 > "Customers_Nov2024.valid"
      valid_count++
    } else {
      print $0 > "Customers_Nov2024.bad_'$TIMESTAMP'"
    }
  } else {
    print $0 > "Customers_Nov2024.bad_'$TIMESTAMP'"
    invalid_count++
  }
}
END {
  print "Valid rows: " valid_count > "/dev/stderr"
  print "Invalid rows: " invalid_count > "/dev/stderr"
}
' Customers_Nov2024.csv || handle_error "Validation failed"

# Porównanie z plikiem OLD
log "Removing duplicates with old data..."
awk -F, '
NR == FNR {old[$0]; next}
!($0 in old) {print > "Customers_Nov2024.final"}
' $OLD_FILE Customers_Nov2024.valid || handle_error "Failed to create final file"

# Sprawdzenie, czy plik finalny istnieje
if [ ! -f "Customers_Nov2024.final" ]; then
  handle_error "Final file not found. Please check earlier steps."
fi

# Tworzenie tabeli w PostgreSQL
log "Setting up PostgreSQL table..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "
DROP TABLE IF EXISTS CUSTOMERS_$NUMERINDEKSU;
CREATE TABLE CUSTOMERS_$NUMERINDEKSU (
    imie TEXT,
    nazwisko TEXT,
    email TEXT,
    lat NUMERIC,
    lon NUMERIC,
    geoloc GEOGRAPHY(POINT, 4326)
);
" || handle_error "Failed to create table"

# Ładowanie danych
log "Loading data into PostgreSQL..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "\copy CUSTOMERS_$NUMERINDEKSU(imie, nazwisko, email, lat, lon) FROM 'Customers_Nov2024.final' WITH CSV HEADER;" || handle_error "Failed to load data"
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "UPDATE CUSTOMERS_$NUMERINDEKSU SET geoloc = ST_SetSRID(ST_MakePoint(lon, lat), 4326);" || handle_error "Failed to update geolocation"

# Generowanie raportu
log "Generating report..."
{
  echo "Liczba wierszy w pliku pobranym z internetu: $(wc -l < Customers_Nov2024.csv)"
  echo "Liczba poprawnych wierszy (po czyszczeniu): $(wc -l < Customers_Nov2024.final)"
} > CUSTOMERS_LOAD_${TIMESTAMP}.dat

# Kwerenda SQL dla klientów w promieniu 50 km
log "Finding best customers..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "
CREATE TABLE IF NOT EXISTS BEST_CUSTOMERS_$NUMERINDEKSU AS
SELECT imie, nazwisko
FROM CUSTOMERS_$NUMERINDEKSU
WHERE ST_Distance(geoloc, ST_SetSRID(ST_MakePoint(-75.67329768604034, 41.39988501005976), 4326)::geography) <= 50000;
" || handle_error "Failed to execute SQL query"

# Eksport danych do CSV
log "Exporting best customers to CSV..."
psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "\copy BEST_CUSTOMERS_$NUMERINDEKSU TO 'BEST_CUSTOMERS_$NUMERINDEKSU.csv' WITH CSV HEADER;" || handle_error "Failed to export data"

# Kompresja wyników
log "Compressing CSV file..."
zip BEST_CUSTOMERS_$NUMERINDEKSU.zip BEST_CUSTOMERS_$NUMERINDEKSU.csv || handle_error "Failed to compress CSV file"

# Wysyłanie e-maila
#log "Sending email..."
#if [ -f "CUSTOMERS_LOAD_${TIMESTAMP}.dat" ] && [ -f "BEST_CUSTOMERS_$NUMERINDEKSU.zip" ]; then
#  echo "Raport i plik CSV w załączeniu." | mailx -s "Raport z przetwarzania danych" \
#    -A "$(pwd)/CUSTOMERS_LOAD_${TIMESTAMP}.dat" \
#    -A "$(pwd)/BEST_CUSTOMERS_$NUMERINDEKSU.zip" \
#    $EMAIL_RECIPIENT || handle_error "Failed to send email"
#else
#  handle_error "One or more files to attach do not exist."
#fi
#
#log "Script execution completed successfully."







