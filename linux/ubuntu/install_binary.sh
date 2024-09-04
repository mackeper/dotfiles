echo_title() { echo -e "\n\033[30;44m $1 \033[0m"; }
echo_error() { echo -e "\033[31m[ error ] $1\033[0m"; }
echo_warning() { echo -e "\033[33m[ warning ] $1\033[0m"; }
echo_info() { echo -e "\033[34m[ info ] $1\033[0m"; }
echo_debug() { echo -e "\033[32m[ debug ] $1\033[0m"; }
echo_success() { echo -e "\033[32m[ success ] $1\033[0m"; }

bin_path="./bin"

install_software() {
    local name="$1"
    local url="$2"
    local binary_path="$3"
    local filename=$(basename "$url")

    [ -f "$bin_path/$name" ] && {
        echo_info "$name already installed at ./bin."
        return 0
    }

    mkdir -p "$bin_path"

    wget -q "$url" &&
        [ -f "$filename" ] || {
        echo_error "Failed to download $url"
        return 1
    }

    if [[ "$filename" == *\.tar\.gz ]]; then
        tar_extract_one_file "$filename" "$name" "$binary_path"
    else
        echo_error "Unsupported file extension: $extension"
        return 1
    fi

    rm $filename
}

function tar_extract_one_file() {
    local tar_file="$1"
    local file="$2"
    local binary_path="$3"
    local base_path=$(echo $binary_path | cut -d'/' -f1)

    tar -xzf "$tar_file" "$binary_path" &&
        [ -f "./$binary_path" ] || {
        echo_error "1 Failed to extracted $binary_path" &&
            return 1
    }

    mv "$binary_path" "$bin_path/$file" &&
        [ -f "$bin_path/$file" ] || {
        echo_error "2 Failed to extracted $file" &&
            return 1
    }
    chmod +x "$bin_path/$file" &&
        echo_success "$file installation successful at ./bin." ||
        echo_error "Installation of $file failed."

    [[ -d "$base_path" && "$base_path" != "." ]] && rm -rf "$base_path"
}

function main() {
    echo_title "Installing binaries"
    install_software "eza" "https://github.com/eza-community/eza/releases/download/v0.19.1/eza_x86_64-unknown-linux-gnu.tar.gz" "./eza"
    install_software "lazygit" "https://github.com/jesseduffield/lazygit/releases/download/v0.43.1/lazygit_0.43.1_Linux_x86_64.tar.gz" "lazygit"
    install_software "gh" "https://github.com/cli/cli/releases/download/v2.55.0/gh_2.55.0_linux_386.tar.gz" "gh_2.55.0_linux_386/bin/gh"
    install_software "nvim" "https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz" "nvim-linux64/bin/nvim"
    install_software "zoxide" "https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-0.9.4-x86_64-unknown-linux-musl.tar.gz" "zoxide"
    install_software "delta" "https://github.com/dandavison/delta/releases/download/0.18.1/delta-0.18.1-x86_64-unknown-linux-gnu.tar.gz" "delta-0.18.1-x86_64-unknown-linux-gnu/delta"
}

main
