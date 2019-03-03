
module Example where

    import qualified Data.Set as Set

    data DirectoryEntry a
        = File String a
        | Directory String [DirectoryEntry a]
        deriving (Show, Read, Eq, Ord)

    directoryWordCount :: DirectoryEntry String -> DirectoryEntry Int
    directoryWordCount (File name w) = File name (length (words w))
    directoryWordCount (Directory name w) = 
        Directory name (map directoryWordCount w)

    directoryMap :: (a -> b) -> DirectoryEntry a -> DirectoryEntry b
    directoryMap f (File n e) = File n $ f e
    directoryMap f (Directory n net) = Directory n $ map (directoryMap f) net


    listCombineAll :: (Monoid f) => [f] -> f
    listCombineAll [] = mempty
    listCombineAll (x:xs) = x <> (listCombineAll xs)

    directoryCombineAll :: (Monoid f) => DirectoryEntry f -> f
    directoryCombineAll (File _ a) = a
    directoryCombineAll (Directory _ items) = listCombineAll (map directoryCombineAll items)

    directoryCombineMap :: (Monoid m) => (a -> m) -> DirectoryEntry a -> m
    directoryCombineMap f d = directoryCombineAll (fmap f d)

    instance Functor DirectoryEntry where
        fmap = directoryMap

    instance Foldable DirectoryEntry where
        foldMap = directoryCombineMap

    instance Traversable DirectoryEntry where
        traverse f (File n a) = File n <$> f a
        traverse f (Directory n items) = Directory n <$> traverse (traverse f) items
    

    contentsSet :: (Ord a) => DirectoryEntry a -> Set.Set a
    contentsSet = foldMap (Set.singleton)