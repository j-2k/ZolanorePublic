using System.Collections;
using System.Collections.Generic;
using UnityEngine;

    //this enum shit took me so long lmao
    //look through how to referenc enum properly through poly & inheri
    public enum CombatType
    {
        Melee,
        Ranged,
        Magic,
        Familiar
    }

public class Ability : ScriptableObject
{
    public string abilityName;


    public CombatType combatType;

    public float cooldownTime;
    public float activeTime;
    public bool singleTrigger;
    public bool bypassCancel;

    public ParticleSystem abilityVFX;

    public TrailRenderer trailVFX;

    public virtual void CacheStart(GameObject parent,GameObject gameManager)
    {

    }

    public virtual void OnActivate(GameObject parent)
    {

    }

    public virtual void OnBeginCoolDown(GameObject parent)
    {

    }

    public virtual void AbilityUpdateActive(GameObject parent)
    {

    }

    public virtual void AbilityUpdateCooldown(GameObject parent)
    {

    }
}
