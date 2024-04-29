using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InvulMatScript : MonoBehaviour
{
    [SerializeField] Material mat;
    EnemyStatManager esm;

    private void Start()
    {
        esm = GetComponentInParent<EnemyStatManager>();
        SetMaterialValue(0);
    }

    public void SetMaterialValue(int a)
    {
        if (a == 1)
        {
            esm.invulnerable = true;
        }
        else
        {
            esm.invulnerable = false;
        }
        mat.SetFloat("_ControlMaterial", a);
    }
}
