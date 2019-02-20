module Example where

    import Data.List

    data DirectoryEntry
        = File String String
        | Directory String [DirectoryEntry]
        deriving (Show, Eq, Ord)

    f = File "hack" "fraud"
    d = Directory "dir" []

    exFile = File "Foo.txt" "fixed"
    hackFile = File "Hack.txt" "fraud"
    dirOne = Directory "dir"
        [hackFile, File "bar.txt" "fraud"]
    recurse = Directory "other" [exFile, dirOne]

    
    name :: DirectoryEntry -> String
    name (File name _) = name
    name (Directory name _) = name


    hasFileTooLong :: DirectoryEntry -> Bool
    hasFileTooLong = hasFileWithContents tooLong
        where
            tooLong contents = length contents > 50

    hasFileTooShort :: DirectoryEntry -> Bool
    hasFileTooShort = hasFileWithContents tooShort
        where
            tooShort contents = length contents < 50

    hasFileWithContents :: (String -> Bool) -> DirectoryEntry -> Bool
    hasFileWithContents func = hasFileWithNameAndContents applyFuncToContents
        where
            applyFuncToContents name contents = func contents
        

    hasFileWithName :: (String -> Bool) -> DirectoryEntry -> Bool
    hasFileWithName func = hasFileWithNameAndContents applyFuncToName
        where
            applyFuncToName name contents = func name
    --  I need you to find all ruby files with the words "class Bar" in them

    hasFileWithNameAndContents :: (String -> String -> Bool) -> DirectoryEntry -> Bool
    hasFileWithNameAndContents func (File name contents) = func name contents
    hasFileWithNameAndContents func (Directory _ children) =
        any (hasFileWithNameANdContents func) children


    class Semigroup a where
        (<>) :: a -> a -> a
        --
    
    class (Semigroup a) => Monoid a where 
        mempty :: a
        --
    
    class Foldable f where
        foldMap :: (Monoid m) => (a -> m) -> f a -> m
        --


    data BinaryTree a 
        = Leaf
        | Node a (BinaryTree a) (BinaryTree a)

    instance Foldable BinaryTree where
        foldMap f (Node a lhs rhs) = (f a) <> (foldMap f lhs) <> (foldMap f rhs)
        foldMap f Leaf = mempty
    

    data All = All Bool

    instance Semigroup All where
        (All f) <> (All g) = All (f || g)
    
    instance Monoid All where
        mempty = All False
    
    getAll :: All -> Bool
    getAll (All a) = a

    all :: (Foldable f) -> (a -> Bool) -> f a -> Bool
    all cb foldable = getAll (foldMap (\x -> All (cb x)) foldable) 


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

    countAllFiles :: DirectoryEntry -> Int
    countAllFiles (File _ _) = 1
    countAllFiles (Directory _ children) =
        sum (map countAllFiles children)

    countFiles :: DirectoryEntry -> Int
    countFiles (File _ _) = 1
    countFiles (Directory _ entries) = sum $ map countFiles entries

    countFilesWhere :: (String -> String -> Bool) -> DirectoryEntry -> Int
    countFilesWhere f (File name value) = if f name value then 1 else 0
    countFilesWhere f (Directory name vals) = sum $ map (countFilesWhere f) vals 