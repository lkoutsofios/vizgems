rules=(
    sev=2
    tmode=keep
    counted=y
    exclude=(
        [0]=(
            tool=pipewire
            txt='*@(Device or resource busy)*'
        )
    )
    include=(
        [0]=(
            tool=kernel
            txt='*'
            sev=1 tmode=keep
        )
    )
)
