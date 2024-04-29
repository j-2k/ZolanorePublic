using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Abilities/BuffAbility")]
public class BuffAbility : Ability
{
    public float scaleIncrease;
    Transform meshTransform;
    CharacterManager cm;
    PlayerManager player;
    ParticleSystem pf;

    public override void CacheStart(GameObject parent, GameObject gameManagerObj)
    {
        cm = parent.GetComponent<CharacterManager>();
        player = parent.GetComponent<PlayerManager>();
        meshTransform = parent.transform.GetChild(0);
        pf = Instantiate(abilityVFX, parent.transform.position, Quaternion.identity, gameManagerObj.transform);
        pf.Stop();
    }

    public override void OnActivate(GameObject parent)
    {
        scaleIncrease = 1;

        pf.Play();
        //bad??? VVVV below
        pf.GetComponent<EGA_EffectSound>().PlaySoundOnce();

        cm.Strength.BaseValue += 10f;
        cm.UpdateStatSkillPoint();
        
        if (player.isMovingAbility != true)
        {
            player.isMovingAbility = false;
        }
    }

    public override void AbilityUpdateActive(GameObject parent)
    {
        if (scaleIncrease <= 1.3f)
        {
            scaleIncrease += 1 * Time.deltaTime;
            scaleIncrease = Mathf.Clamp(scaleIncrease, 1, 1.3f);
            meshTransform.localScale = new Vector3(scaleIncrease, scaleIncrease, scaleIncrease);
        }
    }

    public override void OnBeginCoolDown(GameObject parent)
    {
        pf.Stop();
        cm.Strength.BaseValue -= 10f;
        cm.UpdateStatSkillPoint();
        
        if (player.isMovingAbility != true)
        {
            player.isMovingAbility = false;
        }
    }

    public override void AbilityUpdateCooldown(GameObject parent)
    {
        if (scaleIncrease >= 1f)
        {
            scaleIncrease -= 1 * Time.deltaTime;
            scaleIncrease = Mathf.Clamp(scaleIncrease, 1, 1.3f);
            meshTransform.localScale = new Vector3(scaleIncrease, scaleIncrease, scaleIncrease);
        }
    }

}
