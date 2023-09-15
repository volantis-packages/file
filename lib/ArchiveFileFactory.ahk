class ArchiveFileFactory {
    static _archiveFileTypes := Map(
        "zip", "ZipArchive7z",
        "7z", Map(
            "class", "ZipArchive7z",
            "extra", Map(
                "scriptDir", "", ; Optional, but recommended if exePath is not specified
                "exePath", "" ; Optional, but highly recommended to avoid making assumptions
            )
        )
    )

    static RegisterArchiveFileType(extension, archiveFileType) {
        this._archiveFileTypes[extension] := archiveFileType
    }

    static RegisterArchiveFileTypes(archiveFileTypes) {
        for extension, archiveFileType in archiveFileTypes {
            this._archiveFileTypes[extension] := archiveFileType
        }
    }

    static Create(archiveFilePath, extra := "") {
        SplitPath(archiveFilePath,,, &archiveExt)
        archiveExt := StrLower(archiveExt)

        if (!this._archiveFileTypes.Has(archiveExt) || !this._archiveFileTypes[archiveExt]) {
            throw DataException("Unknown archive file extension: " + archiveExt)
        }

        archiveTypeInfo := this._archiveFileTypes[archiveExt]

        if (Type(archiveTypeInfo) == "String") {
            archiveTypeInfo := Map("class", archiveTypeInfo)
        }

        archiveClass := archiveTypeInfo["class"]

        if (!IsSet(%archiveClass%)) {
            throw DataException("Archvie type " . archiveExt . " points to unknown class: " + archiveClass)
        }

        if (archiveTypeInfo.Has("extra")) {
            archiveTypeInfo["extra"] := List.Clone(archiveTypeInfo["extra"], false)
        } else {
            archiveTypeInfo["extra"] := Map()
        }

        if (extra) {
            extra := List.Merge(archiveTypeInfo["extra"], extra, false)
        } else {
            extra :=archiveTypeInfo["extra"]
        }

        return %archiveClass%(archiveFilePath, extra)
    }
}
