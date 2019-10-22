//
//  BOM.h
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/13/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#ifndef BOM_h
#define BOM_h

// reversed BOM.framework methods
// some prototypes are incomplete and have mismatched return values and arguments

//!BOMTreeIterator
typedef void *BOMTreeIteratorRef;
typedef void *BOMTreeRef;

/**
 *  Creates a new BOMTreeIterator
 *
 *  @param tree Tree to iterate on
 *  @param unk  unknown
 *  @param unk2 unknown
 *  @param unk3 unknown
 *
 *  @return An new instance of BOMTreeIteratorRef
 */
extern BOMTreeIteratorRef BOMTreeIteratorNew(BOMTreeRef tree, int unk, int unk2, int unk3);

/**
 *  Tells you if iteration is over
 *
 *  @param iterator The iterator you are using
 *
 *  @return A value indicating if you have fully iterated over the entire BOMTree
 */
extern BOOL BOMTreeIteratorIsAtEnd(BOMTreeIteratorRef iterator);

/**
 *  Releases a BOMTreeIterator from memory
 *
 *  @param iterator The iterator to free
 */
extern void BOMTreeIteratorFree(BOMTreeIteratorRef iterator);

/**
 *  Gives the size of the current key while iterating
 *
 *  @param iterator The iterator you are using
 *
 *  @return The size in bytes of the current key
 */
extern size_t BOMTreeIteratorKeySize(BOMTreeIteratorRef iterator);

/**
 *  Gives the data of the current key while iterating
 *
 *  @param iterator The iterator you are using
 * 
 *  @return Pointer to the data containing the key
 */
extern void *BOMTreeIteratorKey(BOMTreeIteratorRef iterator);

/**
 *  Gives the size of the current value while iterating
 *
 *  @param iterator The iterator you are using
 *
 *  @return The size in bytes of the current value
 */
extern size_t BOMTreeIteratorValueSize(BOMTreeIteratorRef iterator);

/**
 *  Gives the data of the current value while iterating
 *
 *  @param iterator The iterator you are using
 *
 *  @return Pointer to the data containing the value
 */
extern void *BOMTreeIteratorValue(BOMTreeIteratorRef iterator);

/**
 *  Moves to the next value. You use this to step the iterator after you have consumed
 *  a key/value pair.
 *
 *  @param iterator The iterator you are using
 */
extern void BOMTreeIteratorNext(BOMTreeIteratorRef iterator);

// Not reversed, but it's there
extern void BOMTreeIteratorSet(BOMTreeIteratorRef iterator, int key, int arg2, int arg3);


//!BOMFile
typedef void * BOMFileRef;
extern OSErr BOMFileNewFromCFReadStream(BOMFileRef *bom, CFReadStreamRef stream, BOOL unk);
extern void *BOMFileRead(BOMFileRef bom);
extern OSErr BOMFileClose(BOMFileRef bom);

//!BOMStorage
typedef void *BOMStorageRef;
typedef void *BomSys;
typedef uint32_t BOMBlockID;

extern BOMStorageRef BOMStorageOpen(const char *path, BOOL forWriting);
extern void BOMStorageFree(BOMStorageRef theBOM);
extern BOMStorageRef BOMStorageOpenWithSys(const char *path, BOOL unk, BomSys sys);
extern const char *BOMStorageFileName(BOMStorageRef storage);
extern BOOL BOMStorageCommit(BOMStorageRef storage);
extern BOOL BOMStorageCompact(BOMStorageRef storage);
extern BOMBlockID BOMStorageGetNamedBlock(BOMStorageRef storage, const char *name);
extern int BOMStorageCount(BOMStorageRef storage);
extern BomSys BOMStorageGetSys(BOMStorageRef storage);
extern size_t BOMStorageSizeOfBlock(BOMStorageRef inStorage, BOMBlockID inBlockID);
int BOMStorageCopyFromBlock(BOMStorageRef inStorage, BOMBlockID inBlockID, void *outData);
extern BOOL BOMBomNewWithStorage(BOMStorageRef storage);

//!BOMTree
extern BOMTreeRef BOMTreeOpenWithName(BOMStorageRef storage, const char *name, bool forWriting); // more args
extern BOMTreeRef BOMTreeNewWithName(BOMStorageRef storage, const char *name);
extern int BOMTreeFree(BOMTreeRef tree);
extern BOOL BOMTreeCopyToTree(BOMTreeRef source, BOMTreeRef dest);
extern BOMStorageRef BOMTreeStorage(BOMTreeRef tree);
extern BOOL BOMTreeCommit(BOMTreeRef tree);
extern int BOMTreeSetValue(BOMTreeRef tree, void *key, size_t keySize, void *value, size_t valueSize); // return 1 if failed, 0 if success
extern void *BOMTreeGetValue(BOMTreeRef tree, void *key, size_t keySize); // guess
extern int BOMTreeGetValueSize(BOMTreeRef tree, void *key, size_t keySize, size_t *valueSize); //guess  // return 1 if failed, 0 if success
extern int BOMTreeCount(BOMTreeRef tree);
// guessing it is key and not value
extern int BOMTreeRemoveValue(BOMTreeRef tree, void *key, size_t keySize);

#endif /* BOM_h */
