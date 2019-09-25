# Webserver

function srv
  test -n "$argv"; or set argv "."
  set PORT (get-port)
  open "http://localhost:"$PORT
  superstatic "$DIR" -p "$PORT"
end

# Get IP from hostname

function hostname2ip
  ping -c 1 "$argv" | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
end

# Upload file to transfer.sh
# https://github.com/dutchcoders/transfer.sh/

function transfer
    if test (count $argv) -eq 0
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    end

    ## get temporarily filename, output is written to this file so progress can be showed
    set tmpfile ( mktemp -t transferXXX )

    ## upload stdin or file
    set file $argv[1]

    #if tty -s;
    #then
        set basefile (basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

    #    if [ ! -e $file ];
    #    then
    #        echo "File $file doesn't exists."
    #        return 1
    #    fi

        if test -d $file
            # zip directory and transfer
            set zipfile ( mktemp -t transferXXX.zip )
            # echo (dirname $file)
            #cd (dirname $file) and echo (pwd)
            zip -r -q - $file >> $zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        end
    #else
    #    # transfer pipe
    #    curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    #fi

    ## cat output link
    cat $tmpfile

    ## cleanup
    rm -f $tmpfile
end

function host-headers
  curl --insecure -s -v -o /dev/null "$argv"
end

function view-cert-file
  openssl x509 -in "$argv" -noout -text
end
