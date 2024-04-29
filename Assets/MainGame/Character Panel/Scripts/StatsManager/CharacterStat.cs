using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Juma.CharacterStats
{
    [Serializable]
    public class CharacterStat
    {
        public float BaseValue;

        public virtual float Value
        {
            get
            {
                //is a value is changed then we calculate else we dont do anything
                if (isDirty || BaseValue != lastBaseValue)
                {
                    lastBaseValue = BaseValue;
                    _value = CalculateFinalValue();
                    isDirty = false;
                }
                return _value;
            }
        }

        protected bool isDirty = false;

        protected float _value;

        protected float lastBaseValue = float.MinValue;

        //readonly means you cant change the variable except in the constructor of the class or the declaration itself this will help later incase we accidently modify a statmodifer list or breaking things.
        protected readonly List<StatModifier> statModifiers;
        public readonly ReadOnlyCollection<StatModifier> StatModifiers;     //readonly again because we dont want to change any of the read values we set originally

        public CharacterStat()
        {
            statModifiers = new List<StatModifier>();
            StatModifiers = statModifiers.AsReadOnly(); //this StatModifier will reference the orig statModifier & prohibit changes if however we do changes 
                                                        //in the original statModifier list the changes will reflect here on the readonly version also
        }

        //we can set values of setmodifiers even if its readonly because this is a constructor as said above
        public CharacterStat(float baseValue) : this()
        {
            BaseValue = baseValue;

            /*
            statModifiers = new List<StatModifier>();
            StatModifiers = statModifiers.AsReadOnly(); //this StatModifier will reference the orig statModifier & prohibit changes if however we do changes 
                                                        //in the original statModifier list the changes will reflect here on the readonly version also
                                                        */
        }

        public virtual void AddModifier(StatModifier mod)
        {
            isDirty = true;
            statModifiers.Add(mod);
            statModifiers.Sort(CompareModifierOrder);
        }

        protected virtual int CompareModifierOrder(StatModifier a, StatModifier b)
        {
            if (a.Order < b.Order)
            {
                return -1;
            }
            else if (a.Order > b.Order)
            {
                return 1;
            }

            return 0; //if a == b
        }

        public virtual bool RemoveModifier(StatModifier mod)
        {
            if (statModifiers.Remove(mod))
            {
                isDirty = true;
                return true;
            }
            return false;
        }

        public virtual bool RemoveAllModifiersFromSource(object source)
        {
            //going reverse in the list because of how lists work: if we have 5 objects in a list
            //removing a obj at index 0 will cause obj @ index 1 to go to index 0 > obj @ index 2 to go to index 1 > obj @ index 3 to go to index 2 
            //this is inefficient especially if we have a large list. but if we remove the obj at index 4 which is the 5th object then nothing happens no reordering has to happen.
            //so always do removal in reverse unless in the special case you have to remove at the start of the list.

            bool didRemove = false;

            for (int i = statModifiers.Count - 1; i >= 0; i--)
            {
                if (statModifiers[i].Source == source)
                {
                    isDirty = true;
                    didRemove = true;
                    statModifiers.RemoveAt(i);
                }
            }

            return didRemove;
        }

        protected virtual float CalculateFinalValue()
        {
            float finalValue = BaseValue;
            float sumPercentAdd = 0;


            for (int i = 0; i < statModifiers.Count; i++)
            {
                StatModifier mod = statModifiers[i];

                if (mod.Type == StatModType.Flat)
                {
                    finalValue += mod.Value;
                }
                else if (mod.Type == StatModType.PercentAdd)
                {
                    sumPercentAdd += mod.Value;

                    if (i + 1 >= statModifiers.Count || statModifiers[i + 1].Type != StatModType.PercentAdd)
                    {
                        finalValue *= 1 + sumPercentAdd;
                        sumPercentAdd = 0;
                    }
                }
                else if (mod.Type == StatModType.PercentMult)
                {
                    finalValue *= 1 + (mod.Value/100);
                    //finalValue *= 1 + mod.Value;
                }

                //why the fuck did i write this here what the fuck am i doing
                //finalValue += statModifiers[i].Value;
            }

            //12.0001 != 12 float error avoid wewird float calc errors change the rounded decimal to test & play around with it
            //return (float)Math.Round(finalValue, 4);
            return (float)Math.Round(finalValue, 2);
        }
    }
}
