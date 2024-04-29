
namespace Juma.CharacterStats
{
    public enum StatModType
    {
        Flat = 100,
        PercentAdd = 200,
        PercentMult = 300,
    }

    public class StatModifier
    {
        public readonly float Value;
        public readonly StatModType Type;

        //Order is responsible for the order of mult > 10 * 1.1 + 20 = 31 VS (10 + 20) * 1.1 = 33 < we want this the * has to go over all the base values FIRST
        public readonly int Order;


        //source will help for debugging and how the modifiers are working in order
        public readonly object Source;


        //main constructor
        public StatModifier(float value, StatModType type, int order, object source)
        {
            Value = value;
            Type = type;
            Order = order;
            Source = source;
        }

        //another constructor for setting a custom order when creating a statmodifier
        public StatModifier(float value, StatModType type) : this(value, type, (int)type, null) { }                                  //REQUIRES ONLY VALUE & TYPE
                                                                                                                                     // explainging the after colon part:
                                                                                                                                     //this is the same as the last contructor with the same params except this constructor will automaticaly call the last constructor 
                                                                                                                                     //passing in the value & type supplied & then the INT representation OF THE TYPE this will dictate the order of the *

        //with these additons order & source will be optional while value & type is required when it comes to these mutliple constructors
        //the reasons for these mutliple constructors are for debugging purposes to see exactly what is happening in order this can be seen above at the source object creation
        public StatModifier(float value, StatModType type, int order) : this(value, type, order, null) { }                           //REQUIRES ORDER & LEAVES SOURCE NULL

        public StatModifier(float value, StatModType type, object source) : this(value, type, (int)type, source) { }                //REQUIRES SOURCE & LEAVES ORDER DEFAULT

    }
}
