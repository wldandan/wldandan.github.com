---
layout: post
title: "Java 8 - First impression of Lambda Expression"
date: 2014-06-19 04:56
comments: true
categories: [Java]
---

One of the most prominent and widely used languages in the world has **Evolved**.

Java ever gave us power on object oriented progrmming and we did the best we could with it. 

Now there’s another new elegant way changing the java world-Lambda Expression, that will make our code more expressive, easier to write, less error prone, and easier to parallelize than has been the case with Java.

###Lambda Expression
Let's start from a simple example:

`Suppose we’re asked to total the prices greater than $20, discounted by 10%. Let’s do that in the habitual Java way first.`

####Old way

```
	final List<BigDecimal> prices = Arrays.asList(
		new BigDecimal("10"), new BigDecimal("30"), new BigDecimal("17"), 
		new BigDecimal("20"), new BigDecimal("15"), new BigDecimal("18"), 
	new BigDecimal("45"), new BigDecimal("12"));

	BigDecimal totalOfDiscountedPrices = BigDecimal.ZERO;	
	for(BigDecimal price : prices) { 
			if(price.compareTo(BigDecimal.valueOf(20)) > 0)
					totalOfDiscountedPrices = totalOfDiscountedPrices.add(price.multiply(BigDecimal.valueOf(0.9)));
				}
		System.out.println("Total of discounted prices: " + totalOfDiscountedPrices);
```

####A Better way
Now we can do better, a lot better. Our code can resemble the requirement specification. This will help reduce the gap between the business needs and the code that implements it, further reducing the chances of the requirements being misinterpreted.

```
	final BigDecimal totalOfDiscountedPrices = 
	prices.stream()
	  .filter(price -> price.compareTo(BigDecimal.valueOf(20)) > 0)
	  .map(price -> price.multiply(BigDecimal.valueOf(0.9)))
	  .reduce(BigDecimal.ZERO, BigDecimal::add);
	  
	System.out.println("Total of discounted prices: " + totalOfDiscountedPrices);
```

Instead of explicitly iterating through the prices list, we’re using a few special methods: 

* Using filter() to get the record we are interested 
* Using map() to transfer to another result set
* Using reduce() to compute the total on the result


###Summary
It’s a whole new world in Java. We can now program in an elegant and fluent functional style, with higher-order functions. This can lead to concise code that has fewer errors and is easier to understand, maintain, and parallelize. 