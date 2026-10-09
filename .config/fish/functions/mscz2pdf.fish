function mscz2pdf --description 'Convert .mscz MuseScore file to PDF (requires MuseScore installed via Flatpak)'
    set -l input_file $argv[1]
    set -l output_file $argv[2]

    # Handle --help flag
    if test "$input_file" = "--help"; or test "$input_file" = "-h"
        echo "mscz2pdf - Convert MuseScore .mscz files to PDF (Flatpak)"
        echo ""
        echo "Usage:"
        echo "  mscz2pdf <input.mscz> [output.pdf]"
        echo ""
        echo "Arguments:"
        echo "  input.mscz    Path to the MuseScore file"
        echo "  output.pdf    Optional output path (default: same name with .pdf)"
        echo ""
        echo "Examples:"
        echo "  mscz2pdf score.mscz"
        echo "  mscz2pdf score.mscz custom.pdf"
        echo "  mscz2pdf ~/Scores/song.mscz ~/PDFs/song.pdf"
        return 0
    end

    if test -z "$input_file"
        echo "Usage: mscz2pdf <input.mscz> [output.pdf]"
        echo "  If output.pdf is omitted, uses same name with .pdf extension"
        echo "Run 'mscz2pdf --help' for more details."
        return 1
    end

    if not test -f "$input_file"
        echo "Error: File '$input_file' not found"
        return 1
    end

    if test -z "$output_file"
        set output_file (string replace -r '\.mscz$' '.pdf' "$input_file")
    end

    flatpak run org.musescore.MuseScore -o "$output_file" "$input_file"
    and echo "✅ Exported to: $output_file"
end