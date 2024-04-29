using System.Collections;
using UnityEngine;

namespace Polyart
{
#if UNITY_EDITOR
    using UnityEditor;
    [ExecuteInEditMode]
#endif

    public class FoliageInteractor : MonoBehaviour
    {
        [Range(0f, 10f)]
        public float interactRadius = 2.0f;
        [Range(0f, 200f)]
        public float interactStrength = 10f;
      

        void Update()
        {
            Shader.SetGlobalFloat("_InteractionStrength", interactStrength);
            Shader.SetGlobalFloat("_InteractionRadius", interactRadius);
            Shader.SetGlobalVector("_ActorPosition", this.transform.position);

        }
    
    
    }
}
