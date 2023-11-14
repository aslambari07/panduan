import 'package:flutter/material.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class ArticleCardOneShimmer extends StatelessWidget {
  const ArticleCardOneShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
                color: greyColor, borderRadius: BorderRadius.circular(25)),
          )),
    );
  }
}

class ArticleCardTwoShimmer extends StatelessWidget {
  const ArticleCardTwoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            width: 250,
            height: 260,
            decoration: BoxDecoration(
                color: greyColor, borderRadius: BorderRadius.circular(20)),
          )),
    );
  }
}

class ArticleCardThreeShimmer extends StatelessWidget {
  const ArticleCardThreeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
              color: greyColor, borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}

class ArticleScreenShimmer extends StatelessWidget {
  const ArticleScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const ShimmerContainer(height: 40),
          const ShimmerContainer(height: 40),
          const ShimmerContainer(height: 200),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, index) => const ShimmerContainer(height: 20),
          )
        ],
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double height;
  final double? borderRadius;
  final double? padding;
  const ShimmerContainer(
      {super.key, required this.height, this.borderRadius, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding ?? 10),
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
              color: greyColor,
              borderRadius: BorderRadius.circular(borderRadius ?? 15)),
        ),
      ),
    );
  }
}
