### Knight Online Procs from erthejosea

### SimulateDrops
**Usage**

Procedure takes 2 parameters;

@MonsterSSID &
@NumKills

**@MonsterSSID:** Monster id from K_MONSTER (sSid for table K_MONSTER)

**@NumKills:** Num of kills for simulate | Default value: 10000

**Example:**
```sql
EXEC simulateDrops @MonsterSSID = 2102, @NumKills = 1000
