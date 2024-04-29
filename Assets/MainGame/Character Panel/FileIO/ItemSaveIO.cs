using UnityEngine;

public class ItemSaveIO : MonoBehaviour
{
    private static readonly string baseSavePath;

    static ItemSaveIO()
    {
        baseSavePath = Application.persistentDataPath;
    }

    public static void SaveItems(ItemContainerSaveData items, string fileName)
    {
        FileReadWrite.WriteToBinaryFile(baseSavePath + "/" + fileName + ".dat", items);
    }

    public static ItemContainerSaveData LoadItems(string fileName)
    {
        string filePath = baseSavePath + "/" + fileName + ".dat";

        if (System.IO.File.Exists(filePath))
        {
            return FileReadWrite.ReadFromBinaryFile<ItemContainerSaveData>(filePath);
        }
        return null;
    }
}
