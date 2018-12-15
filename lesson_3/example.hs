module Example where

    data DirectoryEntry
        = File String String
        | Directory String [DirectoryEntry]
        deriving (Show, Eq, Ord)
    
    name :: DirectoryEntry -> String
    name (File name _) = name
    name (Directory name _) = name

    f = File "hack" "fraud"
    d = Directory "dir" []

    changeName :: String -> DirectoryEntry -> DirectoryEntry
    changeName name (File _ t) = File name t 
    -- Note: the "?" are placeholders for you to fill in
    changeName name (Directory _ contents) = Directory name contents

    changeFile :: String -> DirectoryEntry -> DirectoryEntry
    changeFile contents (File name _) = File name contents
    changeFile _ directory = directory

    makeChildless :: DirectoryEntry -> DirectoryEntry
    makeChildless (Directory name _) = Directory name []
    makeChildless f = f

    addEntryUnsafely :: DirectoryEntry -> DirectoryEntry -> DirectoryEntry
    addEntryUnsafely entry (Directory name children) 
        = Directory name (entry:children)
                            -- ^ the : operator adds an element
                            -- to the start of a list
    addEntryUnsafely _ file = file

    data DirectoryError
        = ExpectedDirectory
        deriving (Show, Read, Eq, Ord)

    addEntry :: DirectoryEntry -> DirectoryEntry -> Either DirectoryError DirectoryEntry
    addEntry entry (Directory name children) = Right (Directory name (entry:children))
    addEntry _ _ = Left ExpectedDirectory

    safeChangeFile :: String -> DirectoryEntry -> Either DirectoryError DirectoryEntry
    safeChangeFile contents (File name _) = Right (File name contents)
    safeChangeFile _ _ = Left ExpectedDirectory

    hasFileNamed :: String -> DirectoryEntry -> Bool
    hasFileNamed desired (File name _) = desired == name
    hasFileNamed desired (Directory _ children) =
        any (hasFileNamed desired) children

    fileMatches :: (String -> String -> Bool) -> DirectoryEntry -> Bool
    fileMatches pred (File name value) = pred name value
    fileMatches pred (Directory name children) 
        = any (fileMatches pred) children
    
    hasFileNamed' :: String -> DirectoryEntry -> Bool
    hasFileNamed' n e = fileMatches matcher e 
        where
            matcher name _ = name == n 

    fileNameMatches :: (String -> Bool) -> DirectoryEntry -> Bool
    fileNameMatches p e = fileMatches matcher e
        where
            matcher name _ = p name
    
    fileBodyMatches :: (String -> Bool) -> DirectoryEntry -> Bool
    fileBodyMatches p e = fileMatches matcher e
        where
            matcher _ body = p body

    hasFileNamed'' :: String -> DirectoryEntry -> Bool 
    hasFileNamed'' name b = fileNameMatches (== name) b