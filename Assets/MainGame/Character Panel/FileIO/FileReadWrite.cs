using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

public static class FileReadWrite
{
    public static void WriteToBinaryFile<T>(string filePath, T objectToWrite)
    {
        //using will not require us to stream.Close it will auto do it for us when the using statment ends
        using (Stream stream = File.Open(filePath,FileMode.Create))
        {
            var binaryFormatter = new BinaryFormatter();
            binaryFormatter.Serialize(stream, objectToWrite);
        }
    }

    public static T ReadFromBinaryFile<T>(string filePath)
    {
        using (Stream stream = File.Open(filePath, FileMode.Open))
        {
            var binaryFormatter = new BinaryFormatter();
            return (T)binaryFormatter.Deserialize(stream);
        }
    }
}
