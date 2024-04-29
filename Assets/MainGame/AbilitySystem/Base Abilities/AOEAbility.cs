using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations.Rigging;

[CreateAssetMenu(menuName = "Abilities/AOEAbility")]
public class AOEAbility : Ability
{
    PlayerManager player;
    Transform meshTransform;
    CharacterController cc;
    float timer = 0;
    Animator anim;
    ParticleSystem ps;

    public override void CacheStart(GameObject parent,GameObject gameManagerObj)
    {
        combatType = CombatType.Melee;
        player = parent.GetComponent<PlayerManager>();
        meshTransform = parent.transform.GetChild(0);
        Transform last =  meshTransform.GetChild(meshTransform.childCount-1);
        anim = parent.GetComponent<Animator>();
        cc = parent.GetComponent<CharacterController>();
        ps = Instantiate(abilityVFX, parent.transform.position, Quaternion.identity, gameManagerObj.transform);
        ps.Stop();
    }

    public override void OnActivate(GameObject parent)
    {
        timer = 0;
        player.isMovingAbility = true;
        anim.SetTrigger("SpinTrigger");
        anim.SetBool("Spin",true);
        startSpin = false;
        player.comboStep = 0;
        ps.Play();
    }

    bool startSpin = false;

    public override void AbilityUpdateActive(GameObject parent)
    {
        player.isMovingAbility = true;

        if (!startSpin && isPlaying(anim, "Freeze Spin"))
        {
            startSpin = true;
        }
        
        if (startSpin)
        {
            meshTransform.transform.Rotate(0, 1000 * Time.deltaTime, 0);
        }

        timer += Time.deltaTime;
        if (timer >= 1)
        {
            player.AOEAttack();
            timer = 0;
        }
        player.GroundedUpdate();
        Debug.Log("<color=red>SPINNING</color>");
    }
  
    bool isPlaying(Animator anim, string stateName)
    {
        if (anim.GetCurrentAnimatorStateInfo(1).IsName(stateName) &&
                anim.GetCurrentAnimatorStateInfo(1).normalizedTime < 1.0f)
            return true;
        else
            return false;
    }

    public override void OnBeginCoolDown(GameObject parent)
    {
        anim.SetBool("Spin", false);
        player.isMovingAbility = false;
        meshTransform.transform.localRotation = Quaternion.identity;
        startSpin = false;
        ps.Stop();
    }

    public override void AbilityUpdateCooldown(GameObject parent)
    {
        meshTransform.transform.localRotation = Quaternion.identity;
    }



}
