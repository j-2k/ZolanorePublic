using UnityEngine;
using System.Text;
#if UNITY_EDITOR
using UnityEditor;
#endif
[CreateAssetMenu(menuName = "Items/Item")]
public class Item : ScriptableObject
{
    [SerializeField] string id;
    public string ID { get { return id; } }
    public string ItemName;
    public Sprite Icon;

    [Range(1,100)]
    public int MaxStack = 1;

    protected static readonly StringBuilder sb = new StringBuilder();

    protected static readonly StringBuilder sbLore = new StringBuilder();

#if UNITY_EDITOR
    private void OnValidate() //change to awake later
    {
        string path = AssetDatabase.GetAssetPath(this);
        id = AssetDatabase.AssetPathToGUID(path);
    }
#endif

    public virtual Item GetCopy()
    {
        return this;
    }

    public virtual void Destroy()
    {

    }

    public virtual string GetItemType()
    {
        return "";
    }

    public virtual string GetDescription()
    {
        return "";
    }

    public virtual string GetDescriptionLore()
    {
        return "";
    }
}
