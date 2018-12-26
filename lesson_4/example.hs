
module Example where

    data DirectoryEntry a
        = File String a
        | Directory String [DirectoryEntry a]
        deriving (Show, Read, Eq, Ord)

    directoryMap :: (a -> b) -> DirectoryEntry a -> DirectoryEntry b
    directoryMap f (File n e) = File n $ f e
    directoryMap f (Directory n net) = Directory n $ map (directoryMap f) net

    directoryFoldr :: (a -> b -> b) -> b -> DirectoryEntry a -> b
    directroyFoldr f init (File _ val) = f val init
    directoryFoldr f init (Directory _ vals) = 
        foldr (flip $ directoryFoldr f) init vals

    directoryCombine :: DirectoryEntry (a -> b) -> DirectoryEntry a -> DirectoryEntry b
    directoryCombine (File n f) (File n2 a) 
        = File n2 $ f a
    directoryCombine (File n f) (Directory n2 args) 
        = Directory n2 $ map (directoryMap f) args
    directoryCombine (Directory n fs) ent
        = Directory n $ map (flip directoryCombine ent) fs

    directorySequenceA :: (Applicative f) => DirectoryEntry (f a) -> f (DirectoryEntry a)
    directorySequenceA (File n a) = File n <$> a
    directorySequenceA (Directory n args) = Directory n <$> sequenceA (map directorySequenceA args)

    instance Functor DirectoryEntry where
        fmap = directoryMap

    instance Foldable DirectoryEntry where
        foldr = directoryFoldr

    instance Traversable DirectoryEntry where
        sequenceA = directorySequenceA

    