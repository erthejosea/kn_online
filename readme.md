### Knight Online Procs from erthejosea

### SimulateDrops

**Description**

You can simulate your drops by Monster. This process does not use a **True Random Number Generator (TRNG)** method. The results are not 100% accurate but will give you an idea.

**Usage**

Procedure takes 2 parameters;

@MonsterSSID &
@NumKills

**@MonsterSSID:** Monster id from K_MONSTER (sSid for table K_MONSTER)

**@NumKills:** Num of kills for simulate | Default value: 10000

**Example:**
```sql
EXEC simulateDrops @MonsterSSID = 2102, @NumKills = 1000
```
### Decode Warehouse Data (Inn Hostess)

**Description**

You can review users items in warehouse (inn hostess) by giving username.

**Example:**

```sql
EXEC DecodeWarehouseData @StrUserId  = 'erthejosea'
```

[Alastor Network]