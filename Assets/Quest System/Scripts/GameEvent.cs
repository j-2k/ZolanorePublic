using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class GameEvent
{
    public string EventDescription;
}

public class KillEnemyGameEvent: GameEvent
{
    public string EnemyName;
    public KillEnemyGameEvent(string name)
    {
        EnemyName = name;
    }
}


