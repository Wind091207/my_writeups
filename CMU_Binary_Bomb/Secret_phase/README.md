# Secret Phase

## A. Search for the call to `secret_phase`

![Picture 1](./images/secret_phase_pic1.jfif)

Normally, after solving a phase, the program will call the `phase_defused` function.
At first, we might think that `phase_defused` is simply called to display a message telling us that the phase has been successfully defused.
However, if we go inside `phase_defused` and scroll further down, we discover something interesting:

`call bomb!ILT+475(secret_phase)`

This is where `secret_phase` is called.
The problem is that **we have never been able to trigger `secret_phase`.**
→ Therefore, instead of analyzing `secret_phase` directly, we need to go back and analyze **the condition that allows `phase_defused` to call `secret_phase`.**

### A.1. Analyzing the conditions inside `phase_defused`

![Picture 2](./images/secret_phase_pic2.jfif)

First, the program checks whether we have successfully defused all **6 phases**.
If we have not completed all 6 phases yet, the program jumps out of `phase_defused` and continues with the other phases.

![Picture 5](./images/secret_phase_pic5.jfif)

Then, at the address `00007ff7'675d2cd1`, we encounter the instruction: `lea rcx, [bomb!input_strings]`

When we inspect the address pointed to by `rcx`, we can see that it contains the **answer string we entered for phase 1**.
Next, the program performs an addition: `rcx += rax`.

After checking `rcx` again, we discover that it has moved to the address containing the **answer string for phase 4**.
→ This shows that the program is using the input from **phase 4** for a special check.

### A.2. Discovering the special format of phase 4

![Picture 6](./images/secret_phase_pic6.jfif)

At the address `00007ff7'675d2cf2`, we encounter: `lea rdx, [bomb!string]`
Inspecting the string at this address, we discover the following format: 

`"%d %d %s"`

This is particularly interesting.
Normally, in phase 4, we only enter **two numbers**.
However, the format `%d %d %s` requires:

`integer + integer + string`

→ **This shows that the phase 4 input can contain an additional string after the two numbers.**

### A.3. Analyzing `sscanf`

![Picture 3](./images/secret_phase_pic3.jfif)

Next, the program calls `sscanf(...)` to check whether our input matches the format `%d %d %s`.
At the address `00007ff7`675d2d10`, we once again see `rdx` being assigned an address through:

`lea rdx, [bomb!string]`

Inspecting the string at this address, we find: `DrEvil`
Immediately afterward, `rcx` is assigned another address.
When we inspect the value pointed to by `rcx`, we can see that it contains the **string — the third argument in our input**.

## A.4. The condition for triggering `secret_phase`

![Picture 4](./images/secret_phase_pic4.jfif)

The program then performs a comparison to check whether: `input_string == "DrEvil"`

If the input string is **not `DrEvil`**, the program jumps to `00007ff7'675d2d41` and we will never reach: `call secret_phase`

### → Conclusion

To trigger `secret_phase`, the input for **phase 4** must have the following format:

`<number> <number> DrEvil`

In this case, the answer for phase 4 is: `3 10 DrEvil`

→ **`3 10 DrEvil` is the condition required for the program to enter `secret_phase`.**

---

## B. Inside the function secret_phase!!!!
skipping the stack initialization, we move to the instructions after `call bomb!ILT+1000(__CheckForDebuggerJustMyCode)`.

![Picture 7](./images/secret_phase_pic7.jfif)

First, the program calls `read_line` to read the seventh line of input as a string. The function returns the address of this string in `RAX`, which is then stored at `[rbp+8]`.
Next, the program sets `RCX = [rbp+8]` to pass the string's address as an argument to `atoi` (ASCII to Integer).
Finally, atoi converts the numeric string into an integer and returns the result in EAX. The program then stores this value at [rbp+24].

![Picture 8](./images/secret_phase_pic8.jfif)

Next, the program compares `[rbp+24]` with `1`. If the value is less than `1`, the bomb will explode. Therefore, our input must be greater than or equal to `1`.
In the next branch, `[rbp+24]` is compared with `3E9h` (1001 in decimal). If the value exceeds this limit, the bomb will also explode.

→ This means our input must be within the range `[1, 1001]`.

After passing these checks, the program prepares two arguments for the `fun7` function:

- `EDX = [rbp+24]`: Contains the integer value we entered.
- `RCX = &n1`: Contains the address of `n1` (`00007ff7'675df1b0`), obtained through the `lea` instruction.

When we inspect the memory at this address, we find the value `24h` (36 in decimal).
At this point, we don't know exactly what `n1` represents. However, it might be the root node of a binary search tree.
Finally, the program calls `fun7`. Once the function returns, its result is stored in `EAX`.
The program then checks whether `EAX == 5`.

- If `EAX == 5`, we pass this check.
- Otherwise, the bomb explodes!

→ Therefore, our next goal is to analyze `fun7` and figure out which input causes it to return `5`.
