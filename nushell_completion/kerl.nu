module completions {
    # Build specified release
    export extern "kerl build" [
        release: string@"nu-complete kerl get-releases"
        build_name?: string
    ]

    def "nu-complete kerl get-releases" [] {
        let otp_releases = ($env.KERL_BASE_DIR? | default ($env.HOME | path join ".kerl") | path join "otp_releases")

        if ($otp_releases | path exists) {
            return (open $otp_releases | lines)
        }
    }

    # Build specified git repository
    export extern "kerl build git" [
        git_url: string
        git_version: string
        build_name: string
    ]

    # Install the specified release at the given location
    export extern "kerl install" [
        build_name: string@"nu-complete kerl get-builds"
        directory?: path
    ]

    def "nu-complete kerl get-builds" [] {
        let otp_builds = ($env.KERL_BASE_DIR? | default ($env.HOME | path join ".kerl") | path join "otp_builds")

        if ($otp_builds | path exists) {
            return (open $otp_builds | lines | split column "," release build_name | get build_name)
        }
    }

    # Builds and installs the specified release or git repository at the given location
    export extern "kerl build-install" [
        release: string@"nu-complete kerl get-releases"
        build_name?: string
        directory?: path
    ]

    # Builds and installs the specified git repository at the given location
    export extern "kerl build-install git" [
        git_url: string
        git_version: string
        build_name: string
        directory?: path
    ]

    # Deploy the specified installation to the given host and location
    export extern "kerl deploy" [
        host: string
        directory?: path@"nu-complete kerl get-installations"
        remote_directory?: path
    ]

    def "nu-complete kerl get-installations" [] {
        let otp_installations = ($env.KERL_BASE_DIR? | default ($env.HOME | path join ".kerl") | path join "otp_installations")

        if ($otp_installations | path exists) {
            return (open $otp_installations | lines | split column " " build_name installation | get installation)
        }
    }

    # Update the list of available releases from your source provider
    export extern "kerl update" [
        target: string@"nu-complete kerl update target"
    ]

    def "nu-complete kerl update target" [] {
        ["releases"]
    }

    # List releases, builds and installations
    export extern "kerl list" [
        target: string@"nu-complete kerl list target"
        filter?: string@"nu-complete kerl list filter"
    ]

    def "nu-complete kerl list target" [] {
        ["releases" "builds" "installations"]
    }

    def "nu-complete kerl list filter" [context: string] {
        if ($context | str contains "releases") {
            return ["all"]
        }
    }

    # Delete builds and installations
    export extern "kerl delete" [
        target: string@"nu-complete kerl delete target"
        filter: string@"nu-complete kerl delete filter"
    ]

    def "nu-complete kerl delete target" [] {
        ["build" "installation"]
    }

    def "nu-complete kerl delete filter" [context: string] {
        match ($context | split words | get 2) {
            build => (nu-complete kerl get-builds)
            installation => (nu-complete kerl get-installations)
        }
    }

    # Print the path of a given installation
    export extern "kerl path" [
        installation?: string@"nu-complete kerl path installation"
    ]

    def "nu-complete kerl path installation" [] {
        (nu-complete kerl get-installations | path basename)
    }

    # Print the path of the active installation
    export extern "kerl active" []

    # Print Dialyzer PLT path for the active installation
    export extern "kerl plt" []

    # Print available builds and installations
    export extern "kerl status" []

    # Print a string suitable for insertion in prompt
    export extern "kerl prompt" []

    # Remove compilation artifacts (use after installation)
    export extern "kerl cleanup" [
        build_name: string@"nu-complete kerl cleanup build_name"
    ]

    def "nu-complete kerl cleanup build_name" [] {
        (nu-complete kerl get-builds | append "all")
    }

    # Print the activate script
    export extern "kerl emit-activate" [
        release: string@"nu-complete kerl get-releases"
        build_name: string@"nu-complete kerl get-builds"
        directory: path@"nu-complete kerl get-installations"
        shell?: string@"nu-complete kerl emit-activate shell"
    ]

    def "nu-complete kerl emit-activate shell" [] {
        ["sh" "bash" "fish" "csh" "nushell"]
    }

    # Fetch and install the most recent kerl release
    export extern "kerl upgrade" []

    # Print current version
    export extern "kerl version" []

    # Build and install Erlang/OTP
    export extern kerl []
}

export use completions *
