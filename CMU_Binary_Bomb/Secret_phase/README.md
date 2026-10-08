# Secret Phase

## 1. Search for the call to `secret_phase`

![Picture 1](./images/secret_phase_pic1.jfif)

Normally, after solving a phase, the program will call the `phase_defused` function.
At first, we might think that `phase_defused` is simply called to display a message telling us that the phase has been successfully defused.
However, if we go inside `phase_defused` and scroll further down, we discover something interesting:

```asm
call bomb!ILT+475(secret_phase)
```

This is where `secret_phase` is called.
The problem is that **we have never been able to trigger `secret_phase`.**
→ Therefore, instead of analyzing `secret_phase` directly, we need to go back and analyze **the condition that allows `phase_defused` to call `secret_phase`.**

---

## 2. Analyzing the conditions inside `phase_defused`

![Picture 2](./images/secret_phase_pic2.jfif)

First, the program checks whether we have successfully defused all **6 phases**.
If we have not completed all 6 phases yet, the program jumps out of `phase_defused` and continues with the other phases.
Then, at the address:

```text
00007ff7`675d2cd1
```

we encounter the instruction:

```asm
lea rcx, [bomb!input_strings]
```

When we inspect the address pointed to by `rcx`, we can see that it contains the **answer string we entered for phase 1**.
Next, the program performs an addition:

```text
rcx += rax
```

After checking `rcx` again, we discover that it has moved to the address containing the **answer string for phase 4**.
→ This shows that the program is using the input from **phase 4** for a special check.

---

## 3. Discovering the special format of phase 4
At the address:

```text
00007ff7`675d2cf2
```

we encounter:

```asm
lea rdx, [bomb!string]
```

Inspecting the string at this address, we discover the following format:

```text
"%d %d %s"
```

This is particularly interesting.
Normally, in phase 4, we only enter **two numbers**.
However, the format `%d %d %s` requires:

```text
integer + integer + string
```

→ **This shows that the phase 4 input can contain an additional string after the two numbers.**

---

## 4. Analyzing `sscanf`

![Picture 3](./images/secret_phase_pic3.jfif)

Next, the program calls:

```asm
sscanf(...)
```

to check whether our input matches the format:

```text
%d %d %s
```

At the address:

```text
00007ff7`675d2d10
```

we once again see `rdx` being assigned an address through:

```asm
lea rdx, [bomb!string]
```

Inspecting the string at this address, we find:

```text
DrEvil
```

Immediately afterward, `rcx` is assigned another address.
When we inspect the value pointed to by `rcx`, we can see that it contains the **string — the third argument in our input**.

---

## 5. The condition for triggering `secret_phase`

![Picture 4](./images/secret_phase_pic4.jfif)

The program then performs a comparison to check whether:

```text
input_string == "DrEvil"
```

If the input string is **not `DrEvil`**, the program jumps to:

```text
00007ff7`675d2d41
```

and we will never reach:

```asm
call secret_phase
```

### → Conclusion

To trigger `secret_phase`, the input for **phase 4** must have the following format:

```text
<number> <number> DrEvil
```

In this case, the answer for phase 4 is:

```text
3 10 DrEvil
```

→ **`3 10 DrEvil` is the condition required for the program to enter `secret_phase`.**
