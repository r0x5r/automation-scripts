ff_parallel() {
    if [ $# -ne 2 ]; then
        echo "Usage: ff_parallel <input_file> <output_directory>"
        return 1
    fi

    input_file="$1"
    output_dir="$2"

    # Check if input file exists
    if [ ! -f "$input_file" ]; then
        echo "Input file '$input_file' not found."
        return 1
    fi

    # Create the output directory if it doesn't exist
    mkdir -p "$output_dir"

    # Read each URL from the input file and process them
    while IFS= read -r url; do
        # Extract domain name from URL
        domain=$(echo "$url" | sed -e 's|http://||' -e 's|https://||' -e 's|www.||' -e 's|/.*||')

        # Perform fuzzing using ffuf with specified wordlist
        ffuf -w wordlists/seclists/Fuzzing/fuzz-Bo0oM.txt -u "${url}/FUZZ" -mc 200 > "${output_dir}/${domain}_output.txt"
    done < "$input_file"
}
