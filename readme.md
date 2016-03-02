#### CSV Path:
    "bd/backup_csv"
    the file_name.csv must be equal to model_name to generate it in rails.

#### Code Path:
    "lib/backup_csv" files:
      - 'folder.rb' --> return files in a folder
      - 'csv_file.rb' --> return csv_file :name, :keys, :keys_with_datatype, :datas
      - 'model_file.rb' --> now only add_presence_validation to model
      - 'paths.yml' --> storage useful paths with csv_files and models(to check existence)
      - 'helpers.rb'
  
    "lib/":
      - 'csv.rake' --> task to create_models and restor_datas from csv_file


#### Comands to work:
 
```sh
>personal commands
$rails comands
```

```sh
generate a model scaffold with all attributes presence validation
>rake csv:create_models
```

```sh
to generate DDBB in rails
$rake db:create
$rake db:migrate
```

```sh
restore all instances from csv backup files to DDBB
>rake csv:restore_datas
```

```sh
If you want restore App original state:
$rake db:drop
$rails destroy scaffold user
$rake db:rollback
```