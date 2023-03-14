WHERE imdisk >nul 2>&1 && (
    echo pass
) || (
    echo fail
)
